import 'package:flutter/material.dart';

class FieldMateriaPrimaEsperada extends StatelessWidget {
  const FieldMateriaPrimaEsperada({
    Key? key,
    required TextEditingController controlerMateriaPrimaEsperada,
  })  : _controlerMateriaPrimaEsperada = controlerMateriaPrimaEsperada,
        super(key: key);

  final TextEditingController _controlerMateriaPrimaEsperada;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controlerMateriaPrimaEsperada,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Materia-prima esperada',
        ),
      ),
    );
  }
}
