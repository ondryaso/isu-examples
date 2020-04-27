#include <stdlib.h>

float arr[] = { 12.0f, 1.5f, 3.8f };

int float_comp(const void *p1, const void *p2) {
    const float *pNum1 = (const float *)p1;
    const float *pNum2 = (const float *)p2;

    float num1 = *pNum1;
    float num2 = *pNum2;

    if (num1 < num2) return -1;
    if (num1 == num2) return 0;
    return 1;
}

int main() {
    qsort(arr, 3, sizeof(float), float_comp);
}