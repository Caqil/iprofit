// lib/features/kyc/widgets/document_type_selector.dart
import 'package:flutter/material.dart';
import '../../../core/enums/document_type.dart';

class DocumentTypeSelector extends StatelessWidget {
  final DocumentType selectedType;
  final Function(DocumentType) onChanged;

  const DocumentTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Document Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the type of document you want to submit for KYC verification.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDocumentOption(
                context,
                DocumentType.idCard,
                'ID Card',
                'National ID Card or Government-issued ID',
                Icons.credit_card,
              ),
              const Divider(height: 1),
              _buildDocumentOption(
                context,
                DocumentType.passport,
                'Passport',
                'International Passport',
                Icons.book,
              ),
              const Divider(height: 1),
              _buildDocumentOption(
                context,
                DocumentType.drivingLicense,
                'Driving License',
                'Valid Driver\'s License',
                Icons.directions_car,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentOption(
    BuildContext context,
    DocumentType type,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = selectedType == type;

    return RadioListTile<DocumentType>(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
      value: type,
      groupValue: selectedType,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
