import java.util.*;

public class next_permutation {
    
}


//******NEXT PERMUTATION ***/\

///**SOLUTION***//// 

//find the break point
//if break point exist then find the just greater element than break point and swap
//reverse the array from break point + 1 to end of array

//code part

class Solution{
    public void nextpermutation(int[] nums){
        int n = nums.length;

        int i = n-2;

        while(i >= 0 && nums[i] >= nums[i+1]){
            i--;
        }

        if(i>=0){
            int j = n-1;

            while(nums[j] <= nums[i]){
                j--;
            }
            swap(nums, i, j);
        }
        reverse(nums, i+1, n-1);
    }

    public void swap(int[] nums, int i, int j){
        if(i==j) return;
        nums[i] = nums[i] ^ nums[j];
        nums[j] = nums[i] ^ nums[j];
        nums[i] = nums[i] ^ nums[j];
    }

    public void reverse(int[] nums, int i, int j){
        while(i<j){
            swap(nums, i, j);
            i++;
            j--;
        }
    }
}