moves = 0;

function initialize(initBoard) {
	document.getElementById("clickMe").onclick = undoFunction;
	if(moves == 0){
    	document.getElementById("clickMe").disabled =true;
    }
    var body = document.getElementsByTagName("body")[0];
    var tbl = document.createElement("table");
    tbl.setAttribute("id","mytable");
    var tblBody = document.createElement("tbody");
    tblBody.setAttribute("id","tblbodybig");
    current_table = new Array(new Array(0, 0, 0, 0),
    new Array(0, 0, 0, 0),
    new Array(0, 0, 0, 0),
    new Array(0, 0, 0, 0));

    solved_table = new Array(
    		new Array(false, false, false, false),
    		new Array(false, false, false, false),
    		new Array(false, false, false, false),
    		new Array(false, false, false, false));
    
    visibility_table = new Array(
    		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)),
    		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)),
    		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)),
    		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)));
    
   vis_tables = [];
   sol_tables = [];
   cur_tables = [];   
    
    
    
    for (var j = 0; j < 4; j++) {
        var row = document.createElement("tr");
        var rowIndex = j*1;
        for (var i = 0; i < 4; i++) {
            var cell = document.createElement("td");
            cell.setAttribute("id", rowIndex);
            cell.style.width ="100px";
            cell.style.height ="100px";
            var cellText = document.createTextNode("");
            
            if (initBoard[j][i] != 0 && solved_table[j][i] == false) {
            	cell.innerHTML = '';
            	var newHTML = "<span style='font-size:25pt;text-align:center;'>" + initBoard[j][i] + "</span>";
            	cell.innerHTML = newHTML;
                cell.style.textAlign="center";
                
                
                
                //cellText.appendData(initBoard[j][i]);
                current_table[j][i] = initBoard[j][i];
                solved_table[j][i] = true;
                solvedCells++;
                visibility_table[j][i][0] = false;
                visibility_table[j][i][1] = false;
                visibility_table[j][i][2] = false;
                visibility_table[j][i][3] = false;
                //cell.style.background = "rgb(255,0,0)";
                //cell.style.textAlign ="center";
                //cell.appendChild(cellText);

            } else {
            	cell.appendChild(document.createTextNode(1234));
            }

            row.appendChild(cell);
        }

        tblBody.appendChild(row);

    }

    tbl.appendChild(tblBody);
    body.appendChild(tbl);
    tbl.setAttribute("border", "2");
	
    
}

function sanitize_board(current_table,solved_table){
	//alert(moves);
	if(moves >0){
    	document.getElementById("clickMe").disabled =false;
    }else{
    	document.getElementById("clickMe").disabled = true;
    }
for(var j = 0; j < 4; j++){
	for(var i = 0; i < 4; i++){
				var x = document.getElementById('mytable').rows[j].cells;
				if(solved_table[j][i] == true){
					continue;
				}
			   x[i].innerHTML = '';

				oneTest = true;
                twoTest = true;
                threeTest = true;
                fourTest = true;
                for (var k = 0; k < 4; k++) {
                    if (solved_table[k][i] == true && current_table[k][i] == 1) {
                        oneTest = false;
                    }
                    if (current_table[k][i] == 2 && solved_table[k][i]==true) {
                        twoTest = false;
                    }
                    if (current_table[k][i] == 3 && solved_table[k][i] == true) {
                        threeTest = false;
                    }
                    if (current_table[k][i] == 4 && solved_table[k][i] == true) {
                        fourTest = false;
                    }
                }
                for (var l = 0; l < 4; l++) {
                    if (current_table[j][l] == 1 && solved_table[j][l] == true) {
                        oneTest = false;
                    }
                    if (current_table[j][l] == 2 && solved_table[j][l]== true) {
                        twoTest = false;
                    }
                    if (current_table[j][l] == 3 && solved_table[j][l] == true) {
                        threeTest = false;
                    }
                    if (current_table[j][l] == 4 && solved_table[j][l] == true) {
                        fourTest = false;
                    }
                }
                
                if (j < 2 && i < 2) {
                    check_square(current_table, 0, 0);
                }
                if (j < 2 && i >= 2) {
                    check_square(current_table, 0, 2);
                }
                if (j >= 2 && i < 2) {
                    check_square(current_table, 2, 0);
                }
                if (j >= 2 && i >= 2) {
                    check_square(current_table, 2, 2);
                }
                
                
                var small_table = document.createElement('table');
                var row = document.createElement('tr');
                var new_cell = document.createElement('td');
                var small_tablebody = document.createElement('tbody');
                var smallnumber = 0;
                for (var k = 0; k < 2; k++) {
    				var row = document.createElement("tr");
    					for (var z = 0; z < 2; z++) {
            				var new_cell = document.createElement("td");
           					new_cell.style.width ="50px";
            				new_cell.style.height ="50px";
            				//new_cell.appendChild(document.createTextNode("1"));
            				row.appendChild(new_cell);
            				smallnumber++;
        				}

        			small_tablebody.appendChild(row);

    			}
    			small_table.appendChild(small_tablebody);
    			small_table.setAttribute("border", "0");
    			small_table.setAttribute("id","smallTable");
               
                x[i].appendChild(small_table);
				var length = 4;
				var cell1;
                if (oneTest !== true) {
                	cell1 = x[i].firstChild.rows[0].cells[0];
                	cell1.setAttribute("visibility","hidden");
                    visibility_table[j][i][0] = false;
                	length--;
                }else if (visibility_table[j][i][0] !== false){
                	cell1 = x[i].firstChild.rows[0].cells[0];
                    cell1.appendChild(document.createTextNode("1"));
                    cell1.addEventListener('click', function (event) {
                    	var col = event.target.parentNode.parentNode.parentNode.parentNode.cellIndex;
                    	var row = event.target.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
                        updateTable(col,row,1);
                    });
                }
                if (twoTest !== true) {
                	cell1 = x[i].firstChild.rows[0].cells[1];
                	cell1.setAttribute("visibility","hidden");
                	//alert(visibility_table[j][i][1]+" getting turned to false!");
                    visibility_table[j][i][1] = false;
                    length--;
                }else if(visibility_table[j][i][1] !== false){
                	cell1 = x[i].firstChild.rows[0].cells[1];
                    cell1.appendChild(document.createTextNode("2"));
                    cell1.addEventListener('click', function (event) {
                    	var col = event.target.parentNode.parentNode.parentNode.parentNode.cellIndex;
                    	var row = event.target.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
                        updateTable(col,row,2);
                    });
                }
                if (threeTest !== true) {
                	cell1 = x[i].firstChild.rows[1].cells[0];
                	cell1.setAttribute("visibility","hidden");
                    visibility_table[j][i][2] = false;
                    length--;
                }else if(visibility_table[j][i][2] !== false){
                	cell1 = x[i].firstChild.rows[1].cells[0];
                    cell1.appendChild(document.createTextNode("3"));
                    cell1.addEventListener('click', function (event) {
                    	var col = event.target.parentNode.parentNode.parentNode.parentNode.cellIndex;
                    	var row = event.target.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
                        updateTable(col,row,3);
                    });
                }
                if (fourTest !== true) {
                	cell1 = x[i].firstChild.rows[1].cells[1];
                	cell1.setAttribute("visibility","hidden");
                    visibility_table[j][i][3] = false;
                    length--;
                }else if(visibility_table[j][i][3] !== false){
                	cell1 = x[i].firstChild.rows[1].cells[1];
                    cell1.appendChild(document.createTextNode("4"));
                    cell1.addEventListener('click', function (event) {
                    	var col = event.target.parentNode.parentNode.parentNode.parentNode.cellIndex;
                    	var row = event.target.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
                        updateTable(col,row,4);
                    });
                }		
    			
    			
                
	}
}
visibility_tableCopy = new Array(
		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)),
		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)),
		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)),
		new Array(new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true),new Array(true, true, true, true)));

current_tableCopy = new Array(new Array(0, 0, 0, 0),
	    new Array(0, 0, 0, 0),
	    new Array(0, 0, 0, 0),
	    new Array(0, 0, 0, 0));

solved_tableCopy = new Array(
	    new Array(false, false, false, false),
	    new Array(false, false, false, false),
	    new Array(false, false, false, false),
	   new Array(false, false, false, false));


for(var a = 0; a < 4;a++){
	for(var b = 0; b<4 ;b++){
		for(var c = 0; c<4;c++){
			visibility_tableCopy[a][b][c] = visibility_table[a][b][c];
		}
	}
}
for(var a = 0; a < 4; a++){
	for(var b = 0; b < 4; b++){
		current_tableCopy[a][b] = current_table[a][b];
	}
}
for(var a = 0; a < 4;a++){
	for(var b = 0; b<4;b++){
		solved_tableCopy[a][b] = solved_table[a][b];
	}
}

vis_tables[moves] = visibility_tableCopy;
cur_tables[moves] = current_tableCopy;
sol_tables[moves] = solved_tableCopy;

/*dump(current_tableCopy);
dump(cur_tables[moves]);
dump(cur_tables[0]);
dump(cur_tables);*/

}
function check_square(current_table, baseRow, baseCol) {
    for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 2; j++) {
        
                if (current_table[(baseRow+i)][(baseCol+j)] === 1 && solved_table[(baseRow+i)][(baseCol+j)] === true) {
                    oneTest = false;
                }
                if (current_table[(baseRow+i)][(baseCol+j)] === 2 && solved_table[(baseRow+i)][(baseCol+j)] === true) {
                    twoTest = false;
                }
                if (current_table[(baseRow+i)][(baseCol+j)] === 3 && solved_table[(baseRow+i)][(baseCol+j)] === true) {
                    threeTest = false;
                }
                if (current_table[(baseRow+i)][(baseCol+j)] === 4 && solved_table[(baseRow+i)][(baseCol+j)] === true) {
                    fourTest = false;
                }
            

        }
    }
}
function updateTable(col,row,selected){
	solvedCells++;

    var area = document.getElementById("counterNumber").innerHTML;
    area*1;
    area++;
    document.getElementById("counterNumber").innerHTML = area;
    solved_table[row][col] = true;
	current_table[row][col] = selected;
	var x = document.getElementById('mytable').rows[row].cells[col];
	x.innerHTML = '';
	var newHTML = "<span style='font-size:25pt;text-align:center;'>" + selected + "</span>";
	x.innerHTML = newHTML;
    x.style.textAlign="center";
	
    visibility_table[row][col][0] = false;
    visibility_table[row][col][1] = false;
    visibility_table[row][col][2] = false;
    visibility_table[row][col][3] = false;
    
    if(solvedCells == 16){
    	var counter = document.getElementById("counterNumber");
    	var finalScore = counter.innerHTML;
    	finalScore*1;
    	var wholeArea = document.getElementById("counter");
    	wholeArea.innerHTML = '';
    	
    	wholeArea.innerText = "Game solved on move "+finalScore;
    	alert("You win!");
    	document.getElementById("clickMe").onclick = message;
    }
    
    if(moves == 0){
    	document.getElementById("clickMe").disabled =true;
    }
    moves++;
    sanitize_board(current_table,solved_table);
}

function undoFunction(){
	solvedCells--;
	//alert("got here!");
    var area = document.getElementById("counterNumber").innerHTML;
    area*1;
    area--;
    document.getElementById("counterNumber").innerHTML = area;
   
	if(moves != 0){
		visibility_table = vis_tables[(moves-1)];
		solved_table = sol_tables[(moves-1)];
		current_table = cur_tables[(moves-1)];
		moves-=1;

	}
	//alert(current_table);
	sanitize_board(current_table,solved_table);

}

function dump(obj) {
    var out = '';
    for (var i in obj) {
        out += i + ": " + obj[i] + "\n";
    }

    //alert(out);

    // or, if you wanted to avoid alerts...

    //var pre = document.createElement('pre');
    //pre.innerHTML = out;
    //document.body.appendChild(pre)
}
function message(){
	alert("please reload the page to play again!");
}

