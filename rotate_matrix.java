public class rotate_matrix {
    
}


////****ROTATE MATRIX*****///

///**  APPROACH OR VARIATION**///

// rotate the matrix on 90 degree (for square matrix only)
// for 90 degree we have to do first transpose and then reverse the row of the matrix

//rotate the matrix on 180 degree (for square matrix only)
// for 180 degree we have to do first reverse the row and then reverse the column of the matrix



///**  *(CODE) OPTIMISED APPROACH **///
//*90 DEGREE */


class Solution{
    public void rotate90(int[][] matrix){
        int n = matrix.length;

        for(int i=0;i<n;i++){
            for(int j= i+1;j<n;j++){
                int temp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = temp;
            }
        }

        for(int i=0;i<n;i++){
            int left = 0, right =0;
            while(left < right){
                int temp = matrix[i][left];
                matrix[i][left] = matrix[i][right];
                matrix[i][right] = temp;
                left++;
                right--;
            }
        }
    }
}

//**180 degree**//

class Solutions{
    public void rotate180(int[][] matrix){
        int n = matrix.length;

        for(int i=0;i<n;i++){
            for(int j=0;j<n;j++){
                if(i>n-1-i || (i==n-1-i && j>= n-1-j)){
                    break;
                }

                int temp = matrix[i][j];
                matrix[i][j] = matrix[n-1-i][n-1-j];
                matrix[n-1-i][n-1-j] = temp;
            }
        }
    }
}