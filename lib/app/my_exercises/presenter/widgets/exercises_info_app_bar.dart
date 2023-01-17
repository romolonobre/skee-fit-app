import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/skee_ui/skee_palette.dart';
import '../../../exercises/presenter/cubit/all_exercises_cubit.dart';
import '../../../widgets/flutter_widgets.dart';

class ExercicesInfoAppBar extends StatelessWidget with PreferredSizeWidget {
  ExercicesInfoAppBar({
    Key? key,
  }) : super(key: key);
  final cubit = Modular.get<GetAllExercisesCubit>();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      toolbarHeight: 140,
      automaticallyImplyLeading: false,
      backgroundColor: WEPalette.backgroudColor,
      elevation: 0,
      title: Column(
        children: [
          WEText.title(
            'Select Exercises',
            fontsize: 28,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: SkeeCustomTextfield(
              hintText: "Search by body target",
              onChanged: (value) async => value.length >= 3 ? await cubit.filterExercises(value.toLowerCase()) : null,
              icon: Icons.search,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
