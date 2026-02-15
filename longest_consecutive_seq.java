import java.util.*;
class Solution{
    public static int longCon(int[] nums){
        Set<Integer> set = new HashSet<>();

        for(int num: nums){
            set.add(num);
        }

        int longest = 0;

        for(int num: set){
            if(!set.contains(num - 1)){
                int currNum = num;
                int currStrek = 1;

                while (set.contains(currNum + 1)){
                    currNum++;
                    currStrek++;
                }
                longest = Math.max(longest, currStrek);
            }
        }
        return longest;

    }
}