<?php

declare(strict_types=1);

namespace LsifPhp\Parser;

use PhpParser\Parser;
use PhpParser\ParserFactory as PhpParserFactory;

/** ParserFactory is used to create PHP parsers. */
final class ParserFactory
{
    /** Creates a PHP parser supporting source written for any PHP version through the latest. */
    public static function create(): Parser
    {
        return (new PhpParserFactory())->createForNewestSupportedVersion();
    }
}
