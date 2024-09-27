import 'dart:developer';

import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_gallery_provider.g.dart';

@Riverpod(keepAlive: true)
class CameraGallery extends _$CameraGallery {
  final ImagePicker _picker = ImagePicker();

  @override
  String? build() => null;

  Future<void> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo != null) {
      state = photo.path;
    }
  }

  Future<void> takePhoto(BuildContext context) async {
    while (true) {
      // Verificar y solicitar permisos antes de acceder a la cámara
      final status = await Permission.camera.request();

      if (status.isGranted) {
        // Permiso otorgado, proceder a tomar la foto
        try {
          final XFile? photo = await _picker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.rear,
          );

          if (photo != null) {
            state = photo.path;
          }
        } catch (e) {
          log("Error al tomar la foto: $e");
        }
        break;
      } else if (status.isDenied) {
        // El usuario ha denegado, seguir solicitando
        log("Permiso de cámara denegado. Solicitando nuevamente...");
      } else if (status.isPermanentlyDenied) {
        // El permiso fue denegado permanentemente, guiar al usuario a los ajustes
        _showSettingsDialog(context);
        break;
      }
    }
  }

  void reset() {
    state = null;
  }

  // Mostramos el showSettingsDialog para solicitar permisos cuando el usuario
  // niega el permiso simultaneamente
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomLabel(text: "Permiso de cámara requerido"),
        content: const CustomLabel(
          text:
              "Parece que has denegado permanentemente el acceso a la cámara. "
              "Para continuar, por favor habilita el permiso desde los ajustes.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Abrir los ajustes de la aplicación
              await openAppSettings();
              Navigator.of(context).pop();
            },
            child: const CustomLabel(text: "Abrir ajustes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const CustomLabel(text: "Cancelar"),
          ),
        ],
      ),
    );
  }
}
