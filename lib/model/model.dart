class Notes{
  String title;
  String description;
  String createdAt;
  String id;
  Notes({required this.createdAt,required this.title,required this.description,required this.id});
  factory Notes.fromJson(Map<String,dynamic> json)=>Notes(id:json['id'],createdAt: json['createdAt'], title:json['title'], description: json['description']);
  Map<String,dynamic> toJson()=>{
    "title":title,
    "id":id,
    "createdAt":createdAt,
    "description":description
  };

}
class Tasks{
  String title;
  String createdAt;
  String id;
  String?reminder;
  Tasks({required this.createdAt,required this.title,required this.id,this.reminder,});
  factory Tasks.fromJson(Map<String,dynamic> json)=>Tasks(id:json['id'],createdAt: json['createdAt'], title:json['title'],reminder:json['reminder']);
  Map<String,dynamic> toJson()=>{
    "title":title,
    "id":id,
    "createdAt":createdAt,
    "reminder":reminder,
  };
}
