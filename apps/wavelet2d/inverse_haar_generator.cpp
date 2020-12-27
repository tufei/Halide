#include "Halide.h"

#include "daubechies_constants.h"

namespace {

Halide::Var x("x"), y("y"), c("c");

class inverse_haar : public Halide::Generator<inverse_haar> {
public:
    Input<Buffer<float>> in_{"in", 3};
    Output<Buffer<float>> out_{"out", 2};

    void generate() {
        Func in = Halide::BoundaryConditions::repeat_edge(in_);
        Func mid;

        mid(x, y, c) = select(y % 2 == 0,
                              in(x, y / 2, c) + in(x, y / 2, c + 2),
                              in(x, y / 2, c) - in(x, y / 2, c + 2));

        out_(x, y) = select(x % 2 == 0,
                            mid(x / 2, y, 0) + mid(x / 2, y, 1),
                            mid(x / 2, y, 0) - mid(x / 2, y, 1));
        out_.unroll(x, 2);
    }
};

}  // namespace

HALIDE_REGISTER_GENERATOR(inverse_haar, inverse_haar)
