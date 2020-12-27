#include "Halide.h"

#include "daubechies_constants.h"

namespace {

Halide::Var x("x"), y("y"), c("c");

class daubechies : public Halide::Generator<daubechies> {
public:
    Input<Buffer<float>> in_{"in", 2};
    Output<Buffer<float>> out_{"out", 3};

    void generate() {
        Func in = Halide::BoundaryConditions::repeat_edge(in_);
        Func mid;

        mid(x, y, c) = mux(c,
                           {D0 * in(2 * x - 1, y) + D1 * in(2 * x, y) +
                            D2 * in(2 * x + 1, y) + D3 * in(2 * x + 2, y),
                            D3 * in(2 * x - 1, y) - D2 * in(2 * x, y) +
                            D1 * in(2 * x + 1, y) - D0 * in(2 * x + 2, y)});

        out_(x, y, c) = mux(c,
                            {D0 * mid(x, 2 * y - 1, 0) + D1 * mid(x, 2 * y, 0) +
                             D2 * mid(x, 2 * y + 1, 0) + D3 * mid(x, 2 * y + 2, 0),
                             D0 * mid(x, 2 * y - 1, 1) + D1 * mid(x, 2 * y, 1) +
                             D2 * mid(x, 2 * y + 1, 1) + D3 * mid(x, 2 * y + 2, 1),
                             D3 * mid(x, 2 * y - 1, 0) - D2 * mid(x, 2 * y, 0) +
                             D1 * mid(x, 2 * y + 1, 0) - D0 * mid(x, 2 * y + 2, 0),
                             D3 * mid(x, 2 * y - 1, 1) - D2 * mid(x, 2 * y, 1) +
                             D1 * mid(x, 2 * y + 1, 1) - D0 * mid(x, 2 * y + 2, 1)});
        out_.unroll(c, 4);
    }
};

}  // namespace

HALIDE_REGISTER_GENERATOR(daubechies, daubechies)
