/**
 * @file
 * Contains the declaration of the extractMessage function.
 */

#ifndef EXTRACT_MESSAGE_H
#define EXTRACT_MESSAGE_H

#include <string>
#include "bmp.h"

/**
 * Extracts a message from an image. See the handout for the details
 * of how the message is encoded.
 *
 * @param image The image to extract from.
 * @return The extracted message.
 */
std::string extractMessage(const bmp & image);

#endif
