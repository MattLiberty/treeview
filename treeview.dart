import 'dart:html';
import 'dart:math';


abstract class TreeNode {
  TableElement table = new TableElement(); 
  bool collapsed = true;
  
  Element render();
  
  TreeNode get parent;
  List<TreeNode> get children;
  
  void update() {
    updateNode();
    if(!collapsed || parent == null)
      for(TreeNode node in children) node.update();
  }
  
  void updateNode() {
    bool noChildren = children.isEmpty;
    
    while(!table.rows.isEmpty) table.deleteRow(0);
    table.attributes["cellspacing"] = "0px";
    table.attributes["cellpadding"] = "0px";
    table.attributes["margin"] = "0px";
    
    if(parent != null) {
      bool lastNode = this == parent.children.last;
      
      TableRowElement row = table.addRow();
      TableCellElement cell = row.addCell();
      cell.style
        ..backgroundImage = "url(structure.png)"
        //..borderStyle = "solid"
        //..borderWidth = "1px"
        ..backgroundSize = "66px 100%"
        ..backgroundPositionX = lastNode? "-22px" : "-11px"
        ..verticalAlign = "center"
        ..width = "11px";
      
      SpanElement span = new SpanElement();
      span.style
        ..width = "11px"
        ..height = "11px"    
        ..display = "block"
        ..backgroundImage = "url(structure.png)"
        ..backgroundPositionX = noChildren ? "-33px" 
            : (collapsed ? "-44px" : "-55px");
      cell.append(span);
  
      row.addCell().append(render());
      
      if(!noChildren) {
        cell.onClick.listen((event) {
          collapsed = !collapsed;
          update();
        });
        
        if(!collapsed) {
          row = table.addRow();
          cell = row.addCell();
          if(!lastNode) {
            cell.style
              ..backgroundImage = "url(structure.png)"
              ..backgroundSize = "66px 100%"
              ..backgroundPositionX = "-11px";
          }
          appendChildren(row.addCell());
        }
      }
    } else {
      appendChildren(table.addRow().addCell());
    }
  }
  
  void appendChildren(TableCellElement cell) {
    for(TreeNode node in children) cell.append(node.table);    
  }
}


class Entry extends TreeNode {
  static final Random random = new Random();
  
  List<Entry> _children = null;
  Entry _parent = null;
  int iconX = random.nextInt(36);
  int iconY = random.nextInt(15);
  
  List<Entry> get children {
    if(_children == null) {
      int quantity = random.nextInt(5);
      _children = new List<Entry>(quantity); 
      for(int n = 0; n < quantity; n++) {
        _children[n] = new Entry();
        _children[n]._parent = this;
      }
    }
    return _children;
  }
  
  TreeNode get parent => _parent;
  
  Element render() {
    TableElement tbl = new TableElement();
    TableRowElement row = tbl.addRow();
    SpanElement image = new SpanElement();
    image.style
      ..display = "block"
      ..width = "16px"
      ..height = "16px"
      ..padding = "0px"
      ..backgroundImage = "url(icons.png)"
      ..backgroundPosition
          = "${-16 * iconX}px ${-16 * iconY}px";
    TableCellElement cell = row.addCell();
      cell.style.verticalAlign = "center";
      cell.append(image);
    row.addCell().text ="entry$hashCode"; 
    return tbl;
  }
}


void main() {
  Entry entry;
  while(true) {
    entry = new Entry();
    if(!entry.children.isEmpty) break;
  }
  entry.update();
  document.body.append(entry.table);
}