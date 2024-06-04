import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/di/dependency_injection.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                current is GetCurrentUserLocationState,
            builder: (context, state) {
              return Text(getIt<AuthRepository>().currentAddress ?? "");
            },
          )
        ],
      ),
    );
  }
}
