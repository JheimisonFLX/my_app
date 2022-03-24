import 'package:flutter/material.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {

  final TextEditingController _controladorCampoNumeroConta = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Criando Transferencia') ,) ,
      body: Column(
        children: [
          Editor(controlador:_controladorCampoNumeroConta, rotulo:'Numero da Conta', dica:'0000'),
          Editor(controlador: _controladorCampoValor, rotulo:'Valor', dica: '0.00', icone:Icons.monetization_on),
          ElevatedButton(
              onPressed: () {
                _criaTransferencia(context);
              },
              child: Text('Confirmar')),
        ],
      ),);
  }

  void _criaTransferencia(BuildContext context) {
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text.toString());
    final double? valor = double.tryParse(_controladorCampoValor.text.toString());
    if (numeroConta != null && valor != null){
      final transferenciaCriada = Transferencia(valor, numeroConta);

      debugPrint('Criando transferencia');
      debugPrint('$transferenciaCriada');

      Navigator.pop(context, transferenciaCriada);

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('$transferenciaCriada'),
        ),
      );
    }
  }
}


class Editor extends StatelessWidget {

  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
            fontSize: 24.0
        ),
        decoration: InputDecoration(
            icon: icone != null ? Icon(icone) : null ,
            labelText: rotulo,
            hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


class ListaTransferencias extends StatefulWidget{

  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return ListaTransferenciasState();
  }
 }

 class ListaTransferenciasState extends State<ListaTransferencias>{
   @override
   Widget build(BuildContext context) {
     //widget._transferencias.add(Transferencia(100.0, 3000));
     // TODO: implement build
     return Scaffold(
       appBar: AppBar(title: Text('Transferências'),),
       body: ListView.builder(
         itemCount: widget._transferencias.length,
         itemBuilder: (context, indice) {
           final transferencia = widget._transferencias[indice];
           return ItemTransferencia(transferencia);
         },
       ),
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.add),
         onPressed: () {
           final Future future = Navigator.push(context, MaterialPageRoute(builder: (context){
             return FormularioTransferencia();
           }));
           future.then((trasnferenciaRecebida) {
             debugPrint('chegou no then do future');
             debugPrint('$trasnferenciaRecebida');
             widget._transferencias.add(trasnferenciaRecebida);
           });
         },
       ),
     );
   }
 }


 class ItemTransferencia extends StatelessWidget{

final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
 }

 class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}