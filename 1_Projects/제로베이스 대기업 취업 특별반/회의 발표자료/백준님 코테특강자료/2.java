import java.util.*;

class Solution {
    // https://velog.io/@junhok82/lowerbound-upperbound
    public int lower_bound(int[] data, int target) {
        int begin = 0;
        int end = data.length;
        
        while(begin < end) {
            int mid = (begin + end) / 2;
            
            if(data[mid] >= target) {
                end = mid;
            }
            else {
                begin = mid + 1;
            }
        }
        return end;
    }
    public int upper_bound(int[] data, int target) {
        int begin = 0;
        int end = data.length;
        
        while(begin < end) {
            int mid = (begin + end) / 2;
            
            if(data[mid] <= target) {
                begin = mid + 1;
            }
            else {
                end = mid;
            }
        }
        return end;
    }

    public int[] solution(int n, int k, int[] arr, int[][] queries) {
        int[] ans = new int[k];
        Arrays.sort(arr);
        for (int i=0; i<k; i++) {
            int x = queries[i][0];
            int y = queries[i][1];
            // arr에서 x 이상 y 이하인 수의 개수
            int u = upper_bound(arr, y);
            int l = lower_bound(arr, x);
            ans[i] = u - l;
            //System.out.println(x + " " + y + " " + l + " " + u);
        }
        return ans;
    }
}
