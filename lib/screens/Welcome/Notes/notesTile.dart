import 'package:flutter/material.dart';
import 'package:testify/screens/Welcome/Notes/noteDetails.dart';
class NotesTile extends StatelessWidget {
  final int noteId;
  final String noteText;
  NotesTile({required this.noteId,required this.noteText});
  @override
  Widget build(BuildContext context) {
    String substring;
    if (noteText.length>100){substring=noteText.substring(0,100);}
    else substring=noteText;
    return InkWell(
      onTap: ()async{
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteDetails(noteId: noteId, noteText: noteText)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*(20/926),horizontal:(MediaQuery.of(context).size.width) *(20/428) ),
        height: MediaQuery.of(context).size.height*(137/926),
        width:MediaQuery.of(context).size.height*(137/926) ,
        decoration: BoxDecoration(color: Color(0xff3F2668),borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*10/926)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Note Id: '+noteId.toString(),style: TextStyle(
              color: Color(0xffB0A6C2),
              fontFamily: 'Brandon-med',
              fontSize: (MediaQuery.of(context).size.height) *(15/926),//38,
            ),),
            Text(substring,textAlign:TextAlign.justify,style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Brandon-med',
              fontSize: (MediaQuery.of(context).size.height) *(13/926),//38,
            ),)
          ],
        ),
      ),
    );
  }
}
