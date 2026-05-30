import 'package:campuspulse/presentation/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityStatusBanner extends ConsumerWidget {
  const ConnectivityStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityProvider);
    if (status == ConnectivityStatus.online) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFF222932),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.cloud_off, color: Color(0xFFDCE3EF), size: 16),
          SizedBox(width: 8),
          Text(
            'Vous êtes hors ligne. Certaines données peuvent ne pas être à jour.',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 13,
              color: Color(0xFFDCE3EF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
