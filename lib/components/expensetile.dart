import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";

// ignore: must_be_immutable
class ExpenseTile extends StatelessWidget {
late final String name;
late final String amount;
late final DateTime dateTime;
void Function(BuildContext)? deleteTapped;
void Function(BuildContext)? editTapped;

  ExpenseTile({
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
          color: Colors.blueGrey.shade400,
          borderRadius: BorderRadius.circular(15)
        ),
        
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),

          child: ListTile(
                title: Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  subtitle: Text(
                 '${DateFormat('EEEE, MMM d, yyyy').format(dateTime)}',style:TextStyle(color: Colors.black), // Format date including day of the week
  ),
                trailing: Text('₹'+amount,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                ),
      )
    );
    
  }
}