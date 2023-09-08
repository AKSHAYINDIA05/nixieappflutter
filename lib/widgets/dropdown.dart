import 'package:flutter/material.dart';
import 'package:nixieappflutter/models/gptmodels.dart';
import 'package:nixieappflutter/provider/model_provider.dart';
import 'package:nixieappflutter/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<GptModel>>(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(label: snapshot.error.toString()),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
                child: DropdownButton(
                  items: List<DropdownMenuItem<String>>.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: TextWidget(
                        label: snapshot.data![index].id,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  value: currentModel,
                  onChanged: (value) {
                    setState(
                      () {
                        currentModel = value.toString();
                      },
                    );
                    modelsProvider.setCurrentModel(value.toString());
                  },
                ),
              );
      },
    );
  }
}
