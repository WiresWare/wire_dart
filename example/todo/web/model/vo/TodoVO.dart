class TodoVO {
  bool completed;
  String text;
  String id;

  bool visible = true;

  TodoVO(this.id, this.text, this.completed);

  TodoVO.fromJson(Map<String, dynamic> json):
      id = json['id'],
      text = json['text'],
      completed = json['completed']
      ;

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'text': text,
      'completed': completed
    };
}