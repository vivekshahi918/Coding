public class set_metrix {
    
}

//***SET Matrix zero ***//

/////****SOLUTION****/

//check 1st row if any zero then make a flag row0 = true
//check 1st col if any zero then make a flag col0 = true
//Use 1st row and 1st col as a marker to mark the corresponding row and col to be zero
//Set cells to zero based on markers
//Zero out 1st row id needed
//Zero out 1st col if needed

class  solution{
    public void setZeros(int[][] matrix){
        int row = matrix.length;
        int col = matrix[0].length;

        boolean firstRowZero = false;
        boolean firstColZero = false;

        for(int i=0;i<row;i++){
            if(matrix[i][0]==0){
                firstColZero =  true;
                break;
            }
        }

        for(int j=0;j<col;j++){
            if(matrix[0][j] ==0){
                firstRowZero = true;
                break;
            }
        }

        for(int i=1;i<row;i++){
            for(int j=1;j<col;j++){
                if(matrix[i][j]==0){
                    matrix[i][0] = 0;
                    matrix[0][j] = 0;
                }
            }
        }

        for(int i=1;i<row;i++){
            for(int j =1;j<col;j++){
                if(matrix[i][0]==0 || matrix[0][j]==0){
                    matrix[i][j] = 0;
                }
            }
        }

        if(firstColZero){
            for(int i=0;i<row;i++){
                matrix[i][0] = 0;
            }
        }

        if(firstRowZero){
            for(int j =0;j<col;j++){
                matrix[0][j] = 0;
            }
        }
    }
}




