import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";

class ExpensTile extends StatelessWidget {
late final String name;
late final String amount;
late final DateTime dateTime;
void Function(BuildContext)? deleteTapped;
void Function(BuildContext)? editTapped;

  ExpensTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
    required this.editTapped,
    });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(onPressed: deleteTapped,
          icon: Icons.delete,
          backgroundColor:Colors.red,
          borderRadius: BorderRadius.circular(25),
          
          ),
          SlidableAction(onPressed: editTapped,
          icon: Icons.edit,
          backgroundColor:Colors.grey.shade600,
          borderRadius: BorderRadius.circular(25),
          
          ),
           
        ],
        ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(15)
        ),
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),

          child: ListTile(
                title: Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                subtitle: Text('${dateTime.day} / ${dateTime.month} / ${dateTime.year}'),
                trailing: Text('₹'+amount,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                ),
      )
    );
    
  }
}