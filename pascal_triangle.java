import java.util.*;
public class pascal_triangle {
    
}


//****PASCAL TRIANGLE***/

//****SOLUTION*****/
//Understand the problem statement and the requirements of the problem.
//then make empty list of list to store the result.
//Build Rows one by one and add them to the result list.
//For each row, we can calculate the values based on the previous row.
//The first and last value of each row is always 1.
//For the values in between, we can calculate them as the sum of the two values directly above it in the previous row.
//Finally, return the result list containing all the rows of Pascal's Triangle.

class Solution{
    public List<List<Integer>> generate(int numRows){
        List<List<Integer>> result = new ArrayList<>();
        List<Integer> row = new ArrayList<>();


        for(int i=0;i<numRows;i++){
            row.add(1);

            for(int j = i-1; j> 0;j--){
                row.set(j, row.get(j) + row.get(j-1));
            }

            result.add(new ArrayList<>(row));
        }
        return result;
    }
}
