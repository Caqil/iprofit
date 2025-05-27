// lib/features/kyc/screens/kyc_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/kyc_provider.dart';
import '../../../core/enums/document_type.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../shared/widgets/error_widget.dart';
import 'package:go_router/go_router.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  DocumentType _selectedDocumentType = DocumentType.idCard;
  XFile? _frontDocument;
  XFile? _backDocument;
  XFile? _selfie;
  final _imagePicker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source, int type) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          switch (type) {
            case 1: // Front document
              _frontDocument = image;
              break;
            case 2: // Back document
              _backDocument = image;
              break;
            case 3: // Selfie
              _selfie = image;
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _submitKyc() async {
    if (_frontDocument == null || _selfie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Front document and selfie are required')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // In a real app, you would upload these files to your server first
      // and then use the returned URLs in the KYC submission

      // Simulating upload...
      final frontDocUrl = 'https://example.com/${_frontDocument!.name}';
      final backDocUrl = _backDocument != null
          ? 'https://example.com/${_backDocument!.name}'
          : null;
      final selfieUrl = 'https://example.com/${_selfie!.name}';

      await ref
          .read(kycProvider.notifier)
          .submitKyc(_selectedDocumentType, frontDocUrl, backDocUrl, selfieUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('KYC submitted successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting KYC: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kycState = ref.watch(kycProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('KYC Verification')),
      body: kycState.when(
        data: (data) {
          if (data['kyc_submitted'] == true) {
            final status = data['kyc']['status'];
            return _buildKycStatusView(status);
          }

          return _buildKycSubmissionForm();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => CustomErrorWidget(
          error: error.toString(),
          onRetry: () => ref.refresh(kycProvider),
        ),
      ),
    );
  }

  Widget _buildKycStatusView(String status) {
    IconData statusIcon;
    Color statusColor;
    String statusMessage;

    switch (status) {
      case 'pending':
        statusIcon = Icons.hourglass_top;
        statusColor = Colors.orange;
        statusMessage =
            'Your KYC verification is pending. We will review your documents soon.';
        break;
      case 'approved':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusMessage =
            'Your KYC verification has been approved. You now have full access to all features.';
        break;
      case 'rejected':
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        statusMessage =
            'Your KYC verification was rejected. Please submit new documents.';
        break;
      default:
        statusIcon = Icons.error;
        statusColor = Colors.grey;
        statusMessage = 'Unknown status. Please contact support.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(statusIcon, size: 80, color: statusColor),
            const SizedBox(height: 24),
            Text(
              'KYC Status: ${status.toUpperCase()}',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            if (status == 'rejected')
              LoadingButton(
                onPressed: () {
                  ref.invalidate(kycProvider);
                },
                text: 'Submit New Documents',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKycSubmissionForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit your documents for KYC verification',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'We need to verify your identity to comply with regulations. Your information is secure and will only be used for verification purposes.',
          ),
          const SizedBox(height: 24),

          // Document type selection
          const Text(
            'Document Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<DocumentType>(
            value: _selectedDocumentType,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onChanged: (DocumentType? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedDocumentType = newValue;
                  _backDocument =
                      null; // Reset back document when changing type
                });
              }
            },
            items: DocumentType.values.map((DocumentType type) {
              return DropdownMenuItem<DocumentType>(
                value: type,
                child: Text(_getDocumentTypeName(type)),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Front document upload
          _buildDocumentUploadSection(
            title: 'Front Side of Document',
            description:
                'Please upload a clear photo of the front side of your document',
            image: _frontDocument,
            onTap: () => _showImageSourceDialog(1),
          ),

          const SizedBox(height: 16),

          // Back document upload (only for ID card and driving license)
          if (_selectedDocumentType != DocumentType.passport)
            _buildDocumentUploadSection(
              title: 'Back Side of Document',
              description:
                  'Please upload a clear photo of the back side of your document',
              image: _backDocument,
              onTap: () => _showImageSourceDialog(2),
            ),

          const SizedBox(height: 16),

          // Selfie upload
          _buildDocumentUploadSection(
            title: 'Selfie with Document',
            description: 'Please take a selfie while holding your document',
            image: _selfie,
            onTap: () => _showImageSourceDialog(3),
          ),

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: LoadingButton(
              onPressed: _submitKyc,
              text: 'Submit for Verification',
              isLoading: _isUploading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadSection({
    required String title,
    required String description,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(description),
        const SizedBox(height: 12),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: image == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to upload'),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image.asset(
                          image.path,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                              onPressed: onTap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showImageSourceDialog(int type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, type);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, type);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDocumentTypeName(DocumentType type) {
    switch (type) {
      case DocumentType.idCard:
        return 'ID Card';
      case DocumentType.passport:
        return 'Passport';
      case DocumentType.drivingLicense:
        return 'Driving License';
      default:
        return 'Unknown';
    }
  }
}
