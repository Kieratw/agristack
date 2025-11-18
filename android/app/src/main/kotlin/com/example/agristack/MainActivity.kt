package com.example.agristack

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
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
                        val mean = call.argument<List<Double>>("mean")
                        val std = call.argument<List<Double>>("std")

                        if (imagePath == null || assetPath == null) {
                            result.error(
                                "bad_args",
                                "imagePath/assetPath == null (imagePath=$imagePath, assetPath=$assetPath)",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        try {
                            val outputs = runPytorchInference(
                                context = this,
                                imagePath = imagePath,
                                assetPath = assetPath,
                                inputSize = inputSize,
                                mean = mean,
                                std = std,
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
        inputSize: Int,
        mean: List<Double>?,
        std: List<Double>?,
    ): FloatArray {
        // 1. Załaduj / pobierz z cache moduł
        val module = moduleCache.getOrPut(assetPath) {
            val filePath = assetFilePath(context, assetPath)
            Log.d("AgriStackInference", "Loading model from $filePath")
            Module.load(filePath)         // pełny PyTorch, NIE LiteModuleLoader
        }

        // 2. Wczytaj bitmapę z dysku
        val original: Bitmap = BitmapFactory.decodeFile(imagePath)
            ?: throw IllegalStateException("Nie mogę wczytać bitmapy z $imagePath")

        val bitmap = Bitmap.createScaledBitmap(original, inputSize, inputSize, true)

        // 3. Tensor (CHW, float32)
        val meanArr = (mean ?: listOf(0.0, 0.0, 0.0))
            .map { it.toFloat() }
            .toFloatArray()

        val stdArr = (std ?: listOf(1.0, 1.0, 1.0))
            .map { it.toFloat() }
            .toFloatArray()

        val inputTensor: Tensor = TensorImageUtils.bitmapToFloat32Tensor(
            bitmap,
            meanArr,
            stdArr,
        )

        // 4. Forward
        val outputTensor = module.forward(IValue.from(inputTensor)).toTensor()

        // 5. Zwracamy raw logits / softmax (co tam masz w modelu)
        return outputTensor.dataAsFloatArray
    }

    private fun assetFilePath(context: Context, assetPath: String): String {
        // assetPath z Darta: "assets/models/oilseed_rape_v1.ptl"
        // Plik tymczasowy w /data/data/.../files/
        val fileName = assetPath.replace("/", "_")
        val outFile = File(context.filesDir, fileName)

        if (outFile.exists() && outFile.length() > 0L) {
            return outFile.absolutePath
        }

        outFile.parentFile?.mkdirs()

        // WAŻNE: zamiana "assets/..." -> prawdziwy klucz w paczce Fluttera
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
