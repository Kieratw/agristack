package com.example.agristack

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.ColorMatrix
import android.graphics.ColorMatrixColorFilter
import android.graphics.Matrix
import android.graphics.Paint
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.pytorch.IValue
import org.pytorch.Module
import org.pytorch.Tensor
import org.pytorch.torchvision.TensorImageUtils
import java.io.File
import java.io.FileOutputStream
import java.util.Locale

class MainActivity : FlutterActivity() {

    private val CHANNEL = "agristack/pytorch"
    private val moduleCache = mutableMapOf<String, Module>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "runModel" -> {
                        val imagePath = call.argument<String>("imagePath")
                        val assetPath = call.argument<String>("assetPath")
                        val inputSize = call.argument<Int>("inputSize") ?: 380
                        // Argumenty mean/std z Fluttera ignorujemy w inferencji,
                        // bo model ma normalizację zaszytą w środku (WrappedClassifier).
                        // Przyjmujemy je tylko dla zachowania API, ale nie używamy.
                        val mean = call.argument<List<Double>>("mean")
                        val std = call.argument<List<Double>>("std")

                        if (imagePath == null || assetPath == null) {
                            result.error(
                                "bad_args",
                                "imagePath/assetPath == null",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        try {
                            // Uruchamiamy inferencję
                            val outputs = runPytorchInference(
                                context = this,
                                imagePath = imagePath,
                                assetPath = assetPath,
                                inputSize = inputSize
                            )
                            // FloatArray -> List<double>
                            result.success(outputs.map { it.toDouble() })
                        } catch (e: Exception) {
                            Log.e("AgriStackInference", "Inference failed for $assetPath", e)
                            result.error(
                                "inference_failed",
                                "asset=$assetPath error=${e.message}",
                                e.toString()
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun runPytorchInference(
        context: Context,
        imagePath: String,
        assetPath: String,
        inputSize: Int
    ): FloatArray {
        // 1. Ładowanie modułu
        val module = moduleCache.getOrPut(assetPath) {
            val filePath = assetFilePath(context, assetPath)
            Log.d("AgriStackInference", "Loading model from $filePath")
            Module.load(filePath)
        }

        // 2. Wczytanie oryginału (Full Resolution)
        val original: Bitmap = BitmapFactory.decodeFile(imagePath)
            ?: throw IllegalStateException("Nie mogę wczytać bitmapy z $imagePath")

        // --- POPRAWKA KRYTYCZNA: NORMALIZACJA ---
        // Ponieważ model (WrappedClassifier) ma w sobie zaszyte odejmowanie średniej i dzielenie przez std,
        // tutaj musimy podać jedynie surowe wartości [0.0 - 1.0].
        // Dlatego ustawiamy mean=0 i std=1. To wyłącza normalizację po stronie Androida.
        val noMean = floatArrayOf(0.0f, 0.0f, 0.0f)
        val noStd = floatArrayOf(1.0f, 1.0f, 1.0f)

        // --- TRYB TTA (TEST TIME AUGMENTATION) ---
        Log.d("AgriStackInference", "Applying TTA (4x) for $assetPath")

        // Krok 1: Oryginał (Resize)
        val b1 = Bitmap.createScaledBitmap(original, inputSize, inputSize, true)
        val r1 = forwardPass(module, b1, noMean, noStd)

        // Krok 2: Lustrzane odbicie (Flip)
        val b2 = flipBitmap(b1)
        val r2 = forwardPass(module, b2, noMean, noStd)

        // Krok 3: Zoom (Center Crop 80%)
        val b3temp = centerCropBitmap(original, 0.8f)
        val b3 = Bitmap.createScaledBitmap(b3temp, inputSize, inputSize, true)
        val r3 = forwardPass(module, b3, noMean, noStd)

        // Krok 4: Przyciemnienie (Dark)
        val b4 = darkenBitmap(b1, 0.8f) // 0.8 = 80% jasności
        val r4 = forwardPass(module, b4, noMean, noStd)

        // Uśrednianie wyników (działa zarówno dla logits jak i softmax probabilities)
        val numClasses = r1.size
        val finalResult = FloatArray(numClasses)

        for (i in 0 until numClasses) {
            finalResult[i] = (r1[i] + r2[i] + r3[i] + r4[i]) / 4.0f
        }

        return finalResult
    }

    // --- Helper: Pojedynczy przelot przez sieć ---
    private fun forwardPass(
        module: Module, 
        bitmap: Bitmap, 
        meanArr: FloatArray, 
        stdArr: FloatArray
    ): FloatArray {
        // bitmapToFloat32Tensor wykonuje: (pixel_value - mean) / std
        // Przy mean=0, std=1 dostajemy po prostu pixel_value w zakresie 0..1 (dla RGB)
        val inputTensor: Tensor = TensorImageUtils.bitmapToFloat32Tensor(
            bitmap,
            meanArr,
            stdArr,
        )
        val outputTensor = module.forward(IValue.from(inputTensor)).toTensor()
        return outputTensor.dataAsFloatArray
    }

    // --- Helpers: Augmentacje ---

    private fun flipBitmap(source: Bitmap): Bitmap {
        val matrix = Matrix()
        matrix.preScale(-1.0f, 1.0f) // Odbicie poziome
        return Bitmap.createBitmap(source, 0, 0, source.width, source.height, matrix, true)
    }

    private fun centerCropBitmap(source: Bitmap, scale: Float): Bitmap {
        val width = source.width
        val height = source.height
        
        // Obliczamy nowe wymiary (np. 80% oryginału)
        val newWidth = (width * scale).toInt()
        val newHeight = (height * scale).toInt()
        
        // Obliczamy start X i Y żeby było na środku
        val startX = (width - newWidth) / 2
        val startY = (height - newHeight) / 2
        
        return Bitmap.createBitmap(source, startX, startY, newWidth, newHeight)
    }

    private fun darkenBitmap(source: Bitmap, brightness: Float): Bitmap {
        // Tworzymy mutowalną bitmapę, żeby móc na niej rysować
        val result = Bitmap.createBitmap(source.width, source.height, source.config ?: Bitmap.Config.ARGB_8888)
        val canvas = Canvas(result)
        val paint = Paint()
        
        // Macierz kolorów do zmiany jasności (R, G, B mnożymy przez brightness)
        val cm = ColorMatrix()
        cm.setScale(brightness, brightness, brightness, 1f)
        
        paint.colorFilter = ColorMatrixColorFilter(cm)
        canvas.drawBitmap(source, 0f, 0f, paint)
        return result
    }

    private fun assetFilePath(context: Context, assetPath: String): String {
        val fileName = assetPath.replace("/", "_")
        val outFile = File(context.filesDir, fileName)

        if (outFile.exists() && outFile.length() > 0L) {
            return outFile.absolutePath
        }

        outFile.parentFile?.mkdirs()

        val loader = FlutterInjector.instance().flutterLoader()
        val lookupKey = loader.getLookupKeyForAsset(assetPath)
        Log.d("AgriStackInference", "Copying asset $assetPath as $lookupKey to ${outFile.absolutePath}")

        context.assets.open(lookupKey).use { input ->
            FileOutputStream(outFile).use { output ->
                input.copyTo(output)
                output.flush()
            }
        }

        return outFile.absolutePath
    }
}