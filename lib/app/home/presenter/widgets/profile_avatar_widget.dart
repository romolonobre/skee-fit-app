import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeefiapp/app/home/presenter/cubit/imagepicker_cubit.dart';
import 'package:skeefiapp/app/widgets/flutter_widgets.dart';
import 'package:skeefiapp/app/widgets/skee_button.dart';
import 'package:skeefiapp/app/widgets/snackbar/skee_snackbar_widget.dart';

import '../../../core/skee_ui/skee_palette.dart';

class ProfileAvatarWidget extends StatefulWidget {
  const ProfileAvatarWidget({Key? key}) : super(key: key);

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  final cubit = Modular.get<ImagepickerCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _openPickerImageBottomSheet();
        await HapticFeedback.lightImpact();
      },
      child: BlocConsumer<ImagepickerCubit, ImagepickerState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is ImagepickerError) {
            showSnackbar(context, state.message, SnackBarStatus.error);
          }
        },
        builder: (context, state) {
          if (state is ImagepickerError) {
            return const CircleAvatar(
              radius: 60,
              backgroundColor: SkeePalette.primaryColor,
              child: Icon(Icons.camera_alt_rounded),
            );
          }

          if (state is ImagepickerLoaded) {
            return CircleAvatar(
              radius: 60,
              backgroundColor: SkeePalette.primaryColor,
              backgroundImage: state.image != null ? AssetImage(state.image!.path) : null,
              child: state.image == null ? const Icon(Icons.camera_alt_rounded) : null,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _openPickerImageBottomSheet() async {
    return SkeeBottomSheet.show(
      context,
      floatted: true,
      content: SizedBox(
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeeButton.filled(
                'Gallery',
                ontap: () async {
                  Modular.to.pop();
                  await cubit.pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
              SkeeButton.filled('Camera', ontap: () async {
                Modular.to.pop();
                await cubit.pickImage(ImageSource.camera);
              }),
            ],
          )),
    );
  }
}
