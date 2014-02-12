#!/bin/bash

diff spec/output_fixtures/sample_output.yml <(bin/tree_structure_digest spec/fixtures/sample.yml)
