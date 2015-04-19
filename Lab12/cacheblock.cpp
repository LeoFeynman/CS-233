#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
	uint32_t part1 = (_tag) << (_cache_config.get_num_index_bits() + _cache_config.get_num_block_offset_bits());
	uint32_t part2 = (_index) << _cache_config.get_num_block_offset_bits();
	uint32_t part3 = 0;
	return part1 | part2 | part3;

}
