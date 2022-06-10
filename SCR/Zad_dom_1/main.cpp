/* Do not change this lines */
#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>
#include <mutex>
#include <stdint.h>
#include <thread>
#include <iomanip>

constexpr int64_t N = 4*1024;
int64_t matrix[N][N] = {};

const int NUMBER_OF_THREADS = 4;


/* Do not change this function */
void fillMatrixWithDummyData()
{
    // uzupelnienie macierzy danymi testowymi
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            matrix[i][j] = i * N + j;
        }
    }
}

/* Do not change this function */
int64_t calculateMatrixSumSingleThread(){
    int64_t sum = 0;
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            int64_t element = matrix[i][j];
            sum += pow(element, 0.25);
        }
    }
    return sum;
}

/* Implement this function */
int64_t calculateMatrixSumMultiThread(){
    int64_t sum = 0;
    // Your code...
    std::mutex mutex;
    std::vector<std::thread> th_vec;
    for(int i = 0; i<NUMBER_OF_THREADS;i++){
        th_vec.emplace_back(std::thread([&sum,&mutex,i](){
            int sum_Calc = 0;
            int start = i*N/NUMBER_OF_THREADS;
            int end = (i+1)*N/NUMBER_OF_THREADS;
            for(int j = start; j < end; j++){
                for(int k = 0; k < N; k++){
                    sum_Calc += sqrt(sqrt(matrix[j][k]));
                }
            }
            std::lock_guard<std::mutex> lk_guard(mutex);
            sum += sum_Calc;
        }));
    }
    for(auto &th:th_vec){
        th.join();
    }
    return sum;
}
int main()
{
    fillMatrixWithDummyData();
    int64_t sum = calculateMatrixSumMultiThread();
    std::cout << "Expected sum   = " << 850517472 << std::endl;
    std::cout << "Calculated sum = " << sum << std::endl;
    fillMatrixWithDummyData();
    auto startTime = std::chrono::system_clock::now();
    calculateMatrixSumSingleThread();
    std::chrono::duration<double> elapsedTime_single_thread = std::chrono::system_clock::now() - startTime;
    startTime = std::chrono::system_clock::now();
    calculateMatrixSumMultiThread();
    std::chrono::duration<double> elapsedTime_multi_thread = std::chrono::system_clock::now() - startTime;
    //std::cout << "Single thread execution took: " << setprecision(2) << elapsedTime_single_thread.count() << " s" << std::endl;
    //std::cout << "Multi thread execution took: "  << elapsedTime_multi_thread.count() << " s" << std::endl;

    if(elapsedTime_single_thread.count() > elapsedTime_multi_thread.count()){
        std::cout << "Your solution is faster than single-thread execution.";
    }
    else{
        std::cout << "Your solution is slower than single-thread execution.";
    }
    return 0;
}
