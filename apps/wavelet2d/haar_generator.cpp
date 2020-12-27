#include "Halide.h"

#include "daubechies_constants.h"

namespace {

Halide::Var x("x"), y("y"), c("c");

class haar : public Halide::Generator<haar> {
public:
    Input<Buffer<float>> in_{"in", 2};
    Output<Buffer<float>> out_{"out", 3};

    void generate() {
        Func in = Halide::BoundaryConditions::repeat_edge(in_);
        Func mid;

        mid(x, y, c) = mux(c,
                           {(in(2 * x, y) + in(2 * x + 1, y)),
                            (in(2 * x, y) - in(2 * x + 1, y))});

        out_(x, y, c) = mux(c,
                            {mid(x, 2 * y, 0) + mid(x, 2 * y + 1, 0),
                             mid(x, 2 * y, 1) + mid(x, 2 * y + 1, 1),
                             mid(x, 2 * y, 0) - mid(x, 2 * y + 1, 0),
                             mid(x, 2 * y, 1) - mid(x, 2 * y + 1, 1)}) / 4;
        out_.unroll(c, 4);
    }
};

}  // namespace

HALIDE_REGISTER_GENERATOR(haar, haar)
