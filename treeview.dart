import 'dart:html';
import 'dart:math';
import 'treenode.dart';


class Entry extends StandardTreeNode<Entry> {
  static final Random random = new Random();
  //Шаблон заголовка узла, располагается в html-файле проекта 
  static final Element template = document.getElementById("itemtemplate");
  
  int iconX = random.nextInt(36);
  int iconY = random.nextInt(14);
  
  //Это небольшой хак - заполнение узлов в процессе раскрытия их родителей
  bool filled = false;
  List<Entry> get children {
    if(!filled) {
      int quantity = random.nextInt(5);
      for(int n = 0; n < quantity; n++) addNode(new Entry());
      filled = true;
    }
    return super.children;
  }
 
  //Рендеринг узла в DOM-элемент
  Element render() {
    Element item = template.clone(true);
    SpanElement icon = item.getElementsByClassName("itemicon")[0];
    icon.style.backgroundPosition = "${-16 * iconX}px ${-16 * iconY}px";
    TableCellElement itemcell = item.getElementsByClassName("itemcell")[0];
    itemcell.text =" entry$hashCode";
    return item;
  }
}


void main() {
  Entry entry;
  while(true) {
    entry = new Entry();
    if(!entry.children.isEmpty) break;
  }
  entry.update();
  document.body.nodes.clear();
  document.body.append(entry.table);
}