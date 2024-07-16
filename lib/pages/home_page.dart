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

// class _MyHomePageState extends State<HomePage> {
//   TextEditingController controllerCep = TextEditingController();

//   //focusNode para o campo de texto
//   FocusNode cepFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     //adiciona um listener para quando o campo de texto receber foco
//     //um listener é usado para monitorar mudanças de estado
//     cepFocusNode.addListener(() {});
//   }

//   @override
//   void dispose() {
//     //dispose do FocusNode quando não for mais necessário
//     cepFocusNode.dispose();
//     super.dispose();
//   }

//   var cep = CepModel();
//   final controller = CepController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context)
//               .unfocus(); //remove o foco do campo de texto ao tocar em qualquer lugar da tela
//         },
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 AppColors.primaryColor,
//                 AppColors.primaryColor,
//                 AppColors.secondaryColor,
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 child: ListView(children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 0),
//                           child: SizedBox(
//                             width: 330,
//                             height: 140,
//                             child: Image.asset('assets/images/placa.png'),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 82, right: 82),
//                         child: TextFormField(
//                           keyboardType: TextInputType.number,
//                           controller: controllerCep,
//                           focusNode: cepFocusNode,
//                           onTap: () {
//                             //limpa os resultados da busca anterior ao receber foco
//                           },
//                           decoration: const InputDecoration(
//                             labelText: 'DIGITE SEU CEP',
//                             labelStyle: TextStyle(fontSize: 22.0),
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 15.0, horizontal: 22.0),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(6)),
//                             ),
//                           ),
//                           style: const TextStyle(fontSize: 22.0),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               //verifica se o CEP tem 8 números
//                               if (controllerCep.text.length == 8 &&
//                                   int.tryParse(controllerCep.text) != null) {
//                                 cep = await controller
//                                     .searchCep(controllerCep.text);
//                               } else {
//                                 //snackbar informando ao usuário sobre o formato incorreto do CEP
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                         'Digite um CEP válido com 8 dígitos.'),
//                                   ),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               elevation: 6, //sombra no botão
//                               shadowColor: Colors.black,
//                               backgroundColor: Colors.grey.shade800,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                             ),
//                             child: const Row(
//                               children: [
//                                 Text(
//                                   'PESQUISAR',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     color: AppColors.primaryColor,
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Icon(Icons.search,
//                                     color: AppColors.primaryColor),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(left: 75, right: 75, top: 20),
//                         child: ListenableBuilder(
//                           //escuta o que tá sendo passado no controller
//                           listenable: controller,
//                           builder: (context, child) {
//                             if (controller.isLoading == true) {
//                               return const CircularProgressIndicator();
//                             }

//                             if (controller.isError == true) {
//                               return MyText(
//                                 text:
//                                     'CEP inexistente, digite novamente um CEP válido.',
//                                 fontSize: 20,
//                               );
//                             }
//                             return MyText(
//                                 text:
//                                     '${cep.cep}, ${cep.estado}, ${cep.cidade}, ${cep.bairro}, ${cep.rua}.');
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8, top: 8),
//                 child: SizedBox(
//                   width: 280,
//                   height: 180,
//                   child: Image.asset('assets/images/mapa.gif'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
          initialMessage = true; //mostra a mensagem inicial quando o imput estiver em foco
          cep = CepModel(); //limpa os dados da busca anterior
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
                                controllerCep.clear(); //limpa o texto do imput
                                controller.isError = false; //encerra o estado de erro no controlador
                                initialMessage = true; //mostra a mensagem inicial
                                cep = CepModel(); //limpa os dados da busca anterior
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
                                if (controllerCep.text.length == 8 &&
                                    int.tryParse(controllerCep.text) != null) {
                                  try {
                                    cep = await controller.searchCep(controllerCep.text);
                                    setState(() {
                                      initialMessage = false; //oculta a mensagem inicial após a pesquisa
                                    });
                                  } catch (e) {
                                    //o erro será tratado no controller
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Digite um CEP válido com 8 dígitos.'),
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
                                  Icon(Icons.search, color: AppColors.primaryColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 75, right: 75, top: 20),
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              if (controller.isLoading) {
                                return const CircularProgressIndicator();
                              }

                              if (controller.isError) {
                                return const MyText(
                                  text: 'CEP inexistente, digite um CEP válido.',
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
                                text: '${cep.cep}, ${cep.estado}, ${cep.cidade}, ${cep.bairro}, ${cep.rua}.',
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
