import 'dart:html';

// Шаблон узла
abstract class TreeNodeTemplate {
  TableElement table = new TableElement();                                          
  
  bool get collapsed; // закрыт ли
  List<TreeNodeTemplate> get children; // список дочерних узлов
  TreeNodeTemplate get parent; // родитель
  
  Element render();
  
  void clickOnExpander();
  
  //Обновление (ререндеринг) узла со всеми видимыми дочерними
  void update() {
    updateNode();
    if(!collapsed || parent == null)
      for(TreeNodeTemplate node in children) node.update();
  }
  
  void updateNode() {
    bool noChildren = children.isEmpty;
    
    while(!table.rows.isEmpty) table.deleteRow(0);
    
    if(parent != null) {
      bool lastNode = this == parent.children.last;
      
      TableRowElement row = table.addRow();
      TableCellElement cell = row.addCell();
      cell.className = lastNode ? "lastnodeline" : "nodeline";
      
      SpanElement span = new SpanElement();
      span.className = noChildren ? "nochildrenitem" 
          : (collapsed ? "collapseditem" : "expandeditem");
      cell.append(span);
  
      row.addCell().append(render());
      
      if(!noChildren) {
        cell.onClick.listen((event) {clickOnExpander();});
        
        if(!collapsed) {
          row = table.addRow();
          cell = row.addCell();
          if(!lastNode) cell.className = "nodeline";
          appendChildren(row.addCell());
        }
      }
    } else {
      appendChildren(table.addRow().addCell());
    }
  }
  
  void appendChildren(TableCellElement cell) {
    for(TreeNodeTemplate node in children) cell.append(node.table);    
  }
}


// Стандартный узел со списком дочерних, родителем и методами добавления /
// удаления элементов.
abstract class StandardTreeNode<N extends StandardTreeNode>
    extends TreeNodeTemplate {
  TableElement table = new TableElement(); 
  bool _collapsed = true;
  List<N> _children = new List<N>();
  N _parent = null;
  
  bool get collapsed => _collapsed;
  List<TreeNodeTemplate> get children => _children;
  TreeNodeTemplate get parent => _parent;
  N getNode(int index) => _children[index];
  
  //Действие при клике на раскрыватель
  void clickOnExpander() {
    _collapsed = !collapsed;
    update();
  }
  
  //Добавляет дочерний узел к данному
  void addNode(N node, [int index = -1]) {
    if(node.parent != null) node._parent.removeNode(node);
    if(index == -1) {
      _children.add(node);
    } else {
      _children.insert(index, node);
    }
    node._parent = this;
  }
  
  //Удаляет дочерний узел
  void removeNode(N node) {
    _children.remove(node);
    node._parent = null;
  }  
}

