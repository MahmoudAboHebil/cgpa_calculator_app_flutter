import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info_events.dart';
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    BlocProvider.of<BlocInfo>(context).add(
                      UpdateInfoUserEvent(
                        currentInfo: state.userModelInfo,
                        divisionOption: true,
                        name: 'yyyyyyyyy',
                      ),
                    );
                  },
                  child: Text('Update')),
              SizedBox(
                height: 10,
              ),
              Text(' name :    ${state.userModelInfo.name}'),
              SizedBox(
                height: 10,
              ),
              Text(
                  ' divisionOption :    ${state.userModelInfo.divisionOption}'),
            ],
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
