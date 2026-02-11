/// Translates internal crop names (e.g. 'wheat') to Polish display names.
String translateCropName(String crop) {
  switch (crop.toLowerCase()) {
    case 'wheat':
      return 'Pszenica';
    case 'potato':
      return 'Ziemniak';
    case 'oilseed_rape':
    case 'rapeseed': // handle potential variance
      return 'Rzepak';
    case 'tomato':
      return 'Pomidor';
    // Add more crops as needed
    default:
      // Return capitalized original if unknown, or just return as is
      if (crop.isEmpty) return crop;
      return crop[0].toUpperCase() + crop.substring(1);
  }
}

/// Translates model IDs (e.g. 'wheat_v1.ptl') to Polish display names.
/// Usually we just want to display the crop name associated with the model.
String translateModelId(String modelId) {
  final lower = modelId.toLowerCase();
  if (lower.contains('wheat')) return 'Pszenica';
  if (lower.contains('potato')) return 'Ziemniak';
  if (lower.contains('oilseed_rape') || lower.contains('rapeseed')) {
    return 'Rzepak';
  }
  if (lower.contains('tomato')) return 'Pomidor';

  // Fallback: use crop name translation if modelId matches a crop
  return translateCropName(modelId);
}
