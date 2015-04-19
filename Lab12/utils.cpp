#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	int tag_bits = cache_config.get_num_tag_bits();
	int shift = tag_bits - 1;
	int signed_mask = 0x80000000;
	signed_mask = signed_mask >> shift;
	unsigned ret = (address & signed_mask)>>(32 - tag_bits);
	return ret;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	unsigned mask = 0xffffffff;
	int tag_bits = cache_config.get_num_tag_bits();
	int offset_size = cache_config.get_num_block_offset_bits();
	mask = mask <<(tag_bits - 1);
	mask = mask << 1;
	mask = mask >>(tag_btis - 1);
	mask = mask >> 1;
	unsigned ret = (mask>>offset_size)<<offset_size;
	ret = address & ret;
	ret = ret >> offset_size;
	return ret;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	int offset_size = cache_config.get_num_block_offset_bits();
	int shift = 32 - offset_size - 1;
	int signed_mask = 0x80000000;
	signed_mask = signed_mask >> shift;
	signed_mask = ~signed_mask;
	unsigned ret = address & signed_mask;
	return ret;
}
