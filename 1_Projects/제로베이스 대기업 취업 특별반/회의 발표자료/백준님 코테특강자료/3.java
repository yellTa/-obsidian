import java.util.*;

class Solution {
    int n, k;
    int[] a;
    // 여기서부터
    // 0번 학생이 들어갈 그룹을 정해주고
    // 1번 학생이 들어갈 그룹을 정해주고
    // ...
    // i번 학생이 들어갈 그룹을 정해주고 
    // ...
    // n-1번 학생이 들어갈 그룹을 정해주고
    // 여기까지가 재귀 함수를 이용하면 된다
    // 그 다음에 전투력 차이를 구하면 됨 (i == n)
    public int go(int i, int[] cnt, int[] score) {
        if (i == n) {
            for (int j=0; j<k; j++) {
                if (cnt[j] == 0) { // j번 그룹에 학생이 없음
                    return -1; // 불가능 함
                }
            }
            // 각 학생에 대해서
            // (구성원의 수 * 해당 학생의 협동력 점수)
            // 이걸 모두 더한 값이 그룹의 전투력
            int[] temp = new int[k];
            for (int j=0; j<k; j++) {
                temp[j] = cnt[j] * score[j];
            }
            Arrays.sort(temp);
            return temp[k-1] - temp[0];
        }
        // i번 학생이 들어갈 그룹을 정해주고 
        // cnt[j] = j번 그룹에 있는 학생의 수
        // score[j] = j번 그룹에 있는 학생의 협동력 점수의 합
        int ans = -1;
        for (int j=0; j<k; j++) {
            // i번 학생이 j번 그룹에 들어간다.
            // j번 그룹의 학생의 수가 증가하고
            // j번 그룹에 있는 학생의 협동력 점수의 합도 변함
            cnt[j] += 1;
            score[j] += a[i];
            int cur = go(i+1, cnt, score);
            if (cur != -1) { // i가 j에 들어가서 만들 수 있는 올바른 방법이 없음
                if (ans == -1 || ans > cur) {
                    ans = cur;
                }
            }
            // 이 부분은 i번 학생이 j번 그룹에 들어간게 아님
            score[j] -= a[i];
            cnt[j] -= 1;
        }
        return ans;
    }
    public int solution(int n, int k, int[] a) {
        this.n = n;
        this.k = k;
        this.a = a;
        int[] cnt = new int[k];
        int[] score = new int[k];
        int answer = go(0, cnt, score);
        return answer;
    }
}

