import 'package:flutter_application_1/allimports.dart';

class PersonSentence extends StatefulWidget {
  const PersonSentence({super.key});

  @override
  State<PersonSentence> createState() => _PersonSentenceState();
}

class _PersonSentenceState extends State<PersonSentence> {
  Future<void> showDig()
  async {
    Response r=await APIHandler().checkPatientAgainstCaregiver(3);
    showDialog(context: context, builder: (BuildContext context)=>warningDialog('Greetings', 'Add [Name] where you want to place the names. \nFor example: I like [Name1] and [Name2].', context));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDig();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController sentence=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Color(0xFF9474cc)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Enter Sentence:',style: TextStyle(fontSize: 20,color: Color(0xFF9474cc)),),
            Container(
              width: 200,
              child: SizedBox(
                  width: 250,
                  child: customTextFormField(sentence, '', 'Enter a sentence'),
                ),  
            ),
            SizedBox(height: 10,),
            customButton('Submit', () async {
              if(sentence.text.contains("[Name1]")&&sentence.text.contains("[Name2]"))
              {
                int code=await APIHandler().addSentence(sentence.text);
                if(code==200)
                {
                  showDialog(context: context, builder: (BuildContext context)=>warningDialog('Success', 'Sentence added succesfully.', context));
                }else
                {
                  showDialog(context: context, builder: (BuildContext context)=>warningDialog('Error', 'There was a problem adding this sentence.\nPlease try again.', context));
                }
              }else
              {
                showDialog(context: context, builder: (BuildContext context)=>warningDialog('Problem', 'Please ensure the sentence contains both [Name1] and [Name2] placeholders.', context));
              }
              
            })
          ],
        ),
      ),
    );
  }
}