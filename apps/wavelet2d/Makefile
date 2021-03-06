include ../support/Makefile.inc

.PHONY: build clean test

build: $(BIN)/$(HL_TARGET)/wavelet2d

clean:
	@rm -rf $(BIN)

# By default, %.generator is produced by building %_generator.cpp
$(GENERATOR_BIN)/%.generator: %_generator.cpp $(GENERATOR_DEPS)
	@echo Building Generator $(filter %_generator.cpp,$^)
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) $(filter %.cpp,$^) $(LIBHALIDE_LDFLAGS) -o $@

# Can't have multiple wildcards in Make, so we'll use a macro
# to stamp out all the rules we need
VARIANTS = daubechies haar inverse_daubechies inverse_haar

define GEN_RULE
$$(BIN)/%/$(1).a: $$(GENERATOR_BIN)/$(1).generator
	@echo Running Generator $$<
	@mkdir -p $$(@D)
	@$$< -g $(1) -o $$(@D) target=$$*-no_runtime
endef

$(foreach V,$(VARIANTS),$(eval $(call GEN_RULE,$(V))))

$(BIN)/%/runtime.a: $(GENERATOR_BIN)/haar.generator
	@echo Compiling Halide runtime for target $*
	@mkdir -p $(@D)
	@$< -r runtime -o $(@D) target=$*

$(BIN)/%/wavelet2d: wavelet2d.cpp $(foreach V,$(VARIANTS),$(BIN)/%/$(V).a) $(BIN)/%/runtime.a
	@$(CXX) $(CXXFLAGS) $(IMAGE_IO_CXX_FLAGS) -I$(BIN)/$* $^ $(IMAGE_IO_LIBS) $(LDFLAGS) -o $@

test: $(BIN)/$(HL_TARGET)/wavelet2d
	@echo Testing wavelet2d...
	@$< ../images/gray.png $(<D)

# Don't auto-delete the generators.
.SECONDARY:
