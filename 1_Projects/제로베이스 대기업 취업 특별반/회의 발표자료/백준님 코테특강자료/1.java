class Solution {
    public int dist(int r1, int c1, int r2, int c2) {
        // (r1, c1) -> (r2, c2)가는 거리를 구하는 함수
        // return |r1 - r2| + |c1 - c2|
        int dr = r1 - r2;
        int dc = c1 - c2;
        if (dr < 0) dr = -dr;
        if (dc < 0) dc = -dc;
        return dr + dc;
    }
    public int solution(int n, int[][] house) {
        int[] row = new int[5];
        int[] col = new int[5];
        //(row[1], col[1]): 1번의  위치
        for (int i=0; i<n; i++) {
            for (int j=0; j<n; j++) {
                if (house[i][j] != 0) {
                    // 1, 2, 3, 4
                    row[house[i][j]] = i;
                    col[house[i][j]] = j;
                }
            }
        }
        int ans = 0;
        // 4 -> 1 -> 2 -> 3 -> 4
        ans += dist(row[4], col[4], row[1], col[1]);
        ans += dist(row[1], col[1], row[2], col[2]);
        ans += dist(row[2], col[2], row[3], col[3]);
        ans += dist(row[3], col[3], row[4], col[4]);
        return ans;
    }
}
