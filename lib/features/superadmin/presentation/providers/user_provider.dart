import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/superadmin/presentation/providers/user_notifier.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../../auth/domain/entities/user_entity.dart';

final userProvider =
StateNotifierProvider<UserNotifier, AsyncValue<List<UserEntity>>>((ref) {
  final dio = ref.read(dioClientProvider);
  return UserNotifier(dio);
});