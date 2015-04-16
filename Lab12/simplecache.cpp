#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
	auto set = _cache.find(index);
	for(auto block:set->second){
		if(block.valid() == true && block.tag() == tag)
		{
		return block.get_byte(block_offset);
		}
	}
	return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
	std::vector<SimpleCacheBlock> &cache = _cache[index];
//	if(cache[index].valid() == true){
//		cache[index].replace(tag, data);}
	for(int i = 0; i < cache.size(); i++){
		if(cache[i].valid() == false){
//			block.replace(tag, data);
			cache[i].replace(tag, data);
			return;
		}
	}
	
	cache[0].replace(tag, data);
//		auto set1 = _cache.find(0);
//		for(auto block:set1->second){
//		_cache.insert(0, set1.replace(tag, data));
//		}
	

}
