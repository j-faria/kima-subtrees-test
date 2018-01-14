DNEST4_PATH = DNest4/code
EIGEN_PATH = eigen

export CXX = g++

CXXFLAGS = -pthread -std=c++11 -O3 -DNDEBUG -w -DEIGEN_MPL2_ONLY
LIBS = -L$(DNEST4_PATH) -ldnest4 -L/usr/local/lib
includes = -I$(DNEST4_PATH) -I$(EIGEN_PATH) 

SRCDIR = ./src
SRCS =\
$(SRCDIR)/Data.cpp \
$(SRCDIR)/RVConditionalPrior.cpp \
$(SRCDIR)/RVmodel.cpp \
$(SRCDIR)/main.cpp

OBJS=$(subst .cpp,.o,$(SRCS))
HEADERS=$(subst .cpp,.h,$(SRCS))


all: main examples

%.o: %.cpp
	$(CXX) -c $(includes) -o $@ $< $(CXXFLAGS)


main: $(DNEST4_PATH)/libdnest4.a $(OBJS)
	$(CXX) -o main $(OBJS) $(LIBS) $(CXXFLAGS)


.PHONY: examples
examples: $(DNEST4_PATH)/libdnest4.a $(OBJS)
	@make -C examples/BL2009
	@make -C examples/CoRoT7
	@make -C examples/many_planets
	@make -C examples/default_priors


$(DNEST4_PATH)/libdnest4.a:
	make -C $(DNEST4_PATH)


clean:
	rm -f main $(OBJS)

cleanexamples:
	@make clean -C examples/BL2009
	@make clean -C examples/CoRoT7
	@make clean -C examples/many_planets
	@make clean -C examples/default_priors

cleandnest4:
	@make clean -C $(DNEST4_PATH)

cleanout:
	rm -f sample.txt sample_info.txt levels.txt \
              weights.txt posterior_sample.txt sampler_state.txt \
              posterior_sample_lnlikelihoods.txt

cleanall: cleanout clean cleanexamples cleandnest4
