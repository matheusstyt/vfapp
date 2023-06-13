import 'package:flutter/material.dart';
import 'package:vfapp/main.dart';

class CustomFieldCF extends StatelessWidget {
  const CustomFieldCF({
    Key? key,
    required this.controller,
    required this.isTecladoAtivo,
    required this.foco,
    required this.ativaDesativaTeclado,
    required this.botaoSubmitted,
    this.tituloText = '',
    this.tituloHint = '',
    this.isReadOnly = false,
    this.isAutoFocus = false,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isTecladoAtivo;
  final FocusNode foco;
  final Function ativaDesativaTeclado;
  final Function botaoSubmitted;
  final String tituloText;
  final String tituloHint;
  final bool isReadOnly;
  final bool isAutoFocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Focus(
        onFocusChange: (focus) {
          // Se ganhou foco
          if (focus) {
            VfApp.leitorFactory.configurarLeituraCB(controller: controller, onSubmited: botaoSubmitted);
          }
        },
        child: TextFormField(
          cursorWidth: 12.0,
          keyboardType: isTecladoAtivo
              ? TextInputType.text
              : TextInputType.none,
          controller: controller,
          focusNode: foco,
          readOnly: isReadOnly,
          autofocus: isAutoFocus,
          onTap: () {
            controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length);
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  ativaDesativaTeclado(foco);
                },
                icon: isTecladoAtivo
                    ? Icon(Icons.arrow_back)
                    : Icon(Icons.keyboard),
              ),
              border: OutlineInputBorder(),
              labelText: tituloText,
              hintText: tituloHint),

          // Alessandre comentei o validator pois a borda do texto aparece vermelho com mensagem abaixo
          // ocupando mais espaco em tela. O operador reclamou dessa situacao
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'Campo obrigatório.';
          //   }
          //   return null;
          // },

          onFieldSubmitted: (value) {
            botaoSubmitted();
          },
        ),
      ),
    );
  }
}
