import 'dart:typed_data';
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/data/models/advice_dtos.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:agristack/app/utils/translations.dart';

class PdfService {
  static Future<Uint8List> generateDiagnosisReport({
    required DiagnosisEntryEntity diagnosis,
    required FieldEntity? field,
    required FieldSeasonEntity? season,
    String? advice,
    List<AdviceProduct>? products,
  }) async {
    final pdf = pw.Document();

    pw.Font font;
    pw.Font fontBold;

    try {
      final results = await Future.wait([
        PdfGoogleFonts.robotoRegular(),
        PdfGoogleFonts.robotoBold(),
      ]).timeout(const Duration(seconds: 10));
      font = results[0];
      fontBold = results[1];
    } catch (e) {
      // Fallback to standard fonts if download fails or times out
      // Note: Standard fonts might not support all Polish characters correctly
      font = pw.Font.helvetica();
      fontBold = pw.Font.helveticaBold();
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Raport Agristack',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 24,
                        color: PdfColors.green,
                      ),
                    ),
                    pw.Text(
                      diagnosis.timestamp.toString().substring(0, 16),
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Field Info
              if (field != null) ...[
                pw.Text(
                  'Dane Pola',
                  style: pw.TextStyle(font: fontBold, fontSize: 18),
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Nazwa pola:', style: pw.TextStyle(font: font)),
                    pw.Text(field.name, style: pw.TextStyle(font: fontBold)),
                  ],
                ),
                if (field.area != null)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Powierzchnia:', style: pw.TextStyle(font: font)),
                      pw.Text(
                        '${field.area!.toStringAsFixed(2)} ha',
                        style: pw.TextStyle(font: fontBold),
                      ),
                    ],
                  ),
                if (season != null)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Uprawa:', style: pw.TextStyle(font: font)),
                      pw.Text(
                        translateCropName(season.crop),
                        style: pw.TextStyle(font: fontBold),
                      ),
                    ],
                  ),
                pw.SizedBox(height: 20),
              ],

              // Diagnosis Info
              pw.Text(
                'Diagnoza',
                style: pw.TextStyle(font: fontBold, fontSize: 18),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Wykryty problem:', style: pw.TextStyle(font: font)),
                  pw.Text(
                    diagnosis.displayLabelPl,
                    style: pw.TextStyle(font: fontBold, color: PdfColors.red),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Pewność:', style: pw.TextStyle(font: font)),
                  pw.Text(
                    '${(diagnosis.confidence * 100).toStringAsFixed(1)}%',
                    style: pw.TextStyle(font: fontBold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Advice
              if (advice != null && advice.isNotEmpty) ...[
                pw.Text(
                  'Porada Eksperta AI',
                  style: pw.TextStyle(font: fontBold, fontSize: 18),
                ),
                pw.Divider(),
                pw.Text(
                  advice,
                  style: pw.TextStyle(font: font, fontSize: 12),
                  textAlign: pw.TextAlign.justify,
                ),
                pw.SizedBox(height: 10),
              ] else ...[
                pw.Text(
                  'Brak wygenerowanej porady.',
                  style: pw.TextStyle(font: font, color: PdfColors.grey),
                ),
              ],

              // Products
              if (products != null && products.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                pw.Text(
                  'Rekomendowane środki',
                  style: pw.TextStyle(font: fontBold, fontSize: 14),
                ),
                pw.SizedBox(height: 5),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    // Table Header
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey100,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Nazwa produktu',
                            style: pw.TextStyle(font: fontBold, fontSize: 10),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Dawka',
                            style: pw.TextStyle(font: fontBold, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    // Table Rows
                    ...products.map(
                      (p) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              p.name,
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              p.dose,
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              pw.Spacer(),
              pw.Footer(
                leading: pw.Text(
                  'Wygenerowano przez Agristack',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                trailing: pw.Text(
                  'Strona 1',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
