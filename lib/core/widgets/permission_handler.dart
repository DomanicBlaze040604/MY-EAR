import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler extends StatelessWidget {
  final Widget child;
  final List<Permission> requiredPermissions;
  final Widget Function(List<Permission> denied)? onPermissionDenied;

  const PermissionHandler({
    Key? key,
    required this.child,
    required this.requiredPermissions,
    this.onPermissionDenied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Permission>>(
      future: _checkPermissions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error checking permissions: ${snapshot.error}'),
          );
        }

        final deniedPermissions = snapshot.data ?? [];
        if (deniedPermissions.isNotEmpty) {
          return onPermissionDenied?.call(deniedPermissions) ??
              _buildDefaultDeniedView(context, deniedPermissions);
        }

        return child;
      },
    );
  }

  Future<List<Permission>> _checkPermissions() async {
    final deniedPermissions = <Permission>[];

    for (final permission in requiredPermissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        deniedPermissions.add(permission);
      }
    }

    return deniedPermissions;
  }

  Widget _buildDefaultDeniedView(
    BuildContext context,
    List<Permission> deniedPermissions,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 48, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'Required Permissions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Please grant the following permissions to use this feature:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...deniedPermissions.map(
            (permission) => Text(
              '• ${_getPermissionName(permission)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final results = await Future.wait(
                deniedPermissions.map((p) => p.request()),
              );

              if (results.every((status) => status.isGranted)) {
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushReplacement(MaterialPageRoute(builder: (_) => child));
                }
              }
            },
            child: const Text('Grant Permissions'),
          ),
        ],
      ),
    );
  }

  String _getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Camera';
      case Permission.microphone:
        return 'Microphone';
      case Permission.storage:
        return 'Storage';
      case Permission.location:
        return 'Location';
      default:
        return permission.toString();
    }
  }
}
