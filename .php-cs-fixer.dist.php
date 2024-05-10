<?php declare(strict_types=1);

$finder = (new PhpCsFixer\Finder())
    ->in(__DIR__.'/src')
    ->in(__DIR__.'/tests')
    ->exclude('var')
;

return (new PhpCsFixer\Config())
    ->setRules([
        '@Symfony'               => true,
        'phpdoc_align'           => true,
        'binary_operator_spaces' => [
            'default' => 'align_single_space_minimal',
        ],
        'method_argument_space' => [
            'on_multiline' => 'ensure_fully_multiline',
        ],
        'phpdoc_to_comment'            => false,
        'linebreak_after_opening_tag'  => false,
        'blank_line_after_opening_tag' => false,
        'declare_strict_types'         => true,
        'class_attributes_separation'  => true,
        'trailing_comma_in_multiline'  => [
            'elements' => ['arguments', 'arrays', 'match', 'parameters'],
        ],
        'multiline_whitespace_before_semicolons' => ['strategy' => 'new_line_for_chained_calls'],
        'global_namespace_import'                => ['import_classes' => true],
    ])
    ->setFinder($finder)
    ->setRiskyAllowed(true)
;
