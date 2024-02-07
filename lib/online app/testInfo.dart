import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestInfo extends StatelessWidget {
  const TestInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<BlocInfo, BlocInfoState>(
      builder: (context, state) {
        if (state is BlocInfoLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BlocInfoLoaded) {
          return Center(
            child: Text('Loaded'),
          );
        } else if (state is BlocInfoError) {
          return Center(
            child: Text(state.error),
          );
        }
        return Container();
      },
    ));
  }
}
