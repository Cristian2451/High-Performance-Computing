CXX = mpicxx
CXXFLAGS = -fopenmp -Wall -O3 -g
HDRS = LidDrivenCavity.h SolverCG.h
OBJS = LidDrivenCavity.o LidDrivenCavitySolver.o SolverCG.o
LIBS = -lblas -lboost_program_options -fopenmp
TARGET = solver

%.o: %.cpp $(HDRS)
	$(CXX) $(CXXFLAGS) -o $@ -c $<

$(TARGET): $(OBJS)
	$(CXX) -o $@ $^ $(LIBS)

unittests:
	
	
test:
	mpiexec -np 1 ./$(TARGET) --p 1
	
testlong:
	mpiexec -np 1 ./$(TARGET) --Nx 200 --Ny 200 --p 1 --Re 1000 --dt 0.005 --T 50
	
testOMP:
	mpiexec --bind-to none -x OMP_NUM_THREADS=16 -np 1 ./$(TARGET) --Nx 400 --Ny 400 --Re 1000 --dt 0.001 --T 1

profiler: $(TARGET)
	rm -r test.1.er
	collect -o test.1.er ./$(TARGET) --Nx 200 --Ny 200 --Re 1000 --dt 0.005 --T 50
	analyzer test.1.er

doc:
	doxygen Doxyfile

.PHONY: clean

clean:
	-rm -f *.o $(TARGET)

