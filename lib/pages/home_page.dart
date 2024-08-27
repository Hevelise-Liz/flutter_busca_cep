import 'package:flutter/material.dart';
import 'package:flutter_busca_cep/controllers/cep_controller.dart';
import 'package:flutter_busca_cep/models/cep_model.dart';
import 'package:flutter_busca_cep/widgets/my_text.dart';
import '../colors/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  TextEditingController controllerCep = TextEditingController();

  FocusNode cepFocusNode = FocusNode();
  var cep = CepModel();
  final controller = CepController();
  bool initialMessage = true;

  @override
  void initState() {
    super.initState();

    cepFocusNode.addListener(() {
      if (cepFocusNode.hasFocus) {
        setState(() {
          initialMessage = true;
          cep = CepModel();
        });
      }
    });
  }

  @override
  void dispose() {
    cepFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor,
                AppColors.secondaryColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: SizedBox(
                              width: 330,
                              height: 140,
                              child: Image.asset('assets/images/placa.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 82, right: 82),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: controllerCep,
                            focusNode: cepFocusNode,
                            onTap: () {
                              setState(() {
                                controllerCep.clear();
                                controller.isError = false;
                                initialMessage = true;
                                cep = CepModel();
                                FocusScope.of(context)
                                    .requestFocus(cepFocusNode);
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'DIGITE SEU CEP',
                              labelStyle: TextStyle(fontSize: 22.0),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 22.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                            style: const TextStyle(fontSize: 22.0),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (controllerCep.text.length == 8 &&
                                    int.tryParse(controllerCep.text) != null) {
                                  try {
                                    cep = await controller
                                        .searchCep(controllerCep.text);
                                    setState(() {
                                      initialMessage = false;
                                    });
                                  } catch (e) {}
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: MyText(
                                          text:
                                              'Digite um CEP válido com 8 dígitos.',
                                          fontSize: 13),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                elevation: 6,
                                shadowColor: Colors.black,
                                backgroundColor: Colors.grey.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'PESQUISAR',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.search,
                                      color: AppColors.primaryColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 44, right: 44, top: 20),
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              if (controller.isLoading) {
                                return const CircularProgressIndicator();
                              }

                              if (controller.isError) {
                                return const MyText(
                                  text:
                                      'CEP inexistente, digite um CEP válido.',
                                  fontSize: 20,
                                );
                              }

                              if (initialMessage) {
                                return const MyText(
                                  text: '',
                                  fontSize: 20,
                                );
                              }

                              return MyText(
                                text:
                                    '${cep.cep}, ${cep.estado}, ${cep.cidade}, ${cep.bairro}, ${cep.rua}.',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: SizedBox(
                  width: 280,
                  height: 180,
                  child: Image.asset('assets/images/mapa.gif'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
