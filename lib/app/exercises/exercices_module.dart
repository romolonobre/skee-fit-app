import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/cubit/all_exercises_cubit.dart';
import 'presenter/exercises_screen.dart';
import 'repositories/get_all_exercices_repository_impl.dart';
import 'repositories/get_all_exercises_repository.dart';
import 'services/get_all_exercises_service.dart';
import 'services/get_all_exercises_service_impl.dart';

class ExercisesModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<GetAllExercisesRepository>((i) => GetAllExercisesRepositoryImpl()),
        Bind.lazySingleton<GetAllExercisesService>((i) => GetAllExercisesServiceImpl(repository: i())),
        Bind.lazySingleton((i) => GetAllExercisesCubit(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => ExercisesPage(exercisesModel: const [])),
      ];
}
