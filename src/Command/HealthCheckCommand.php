<?php declare(strict_types=1);

namespace App\Command;

use Override;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class HealthCheckCommand extends Command
{
    protected static $defaultName = 'app:health-check';

    #[Override]
    protected function configure(): void
    {
        parent::configure();

        $this
            ->setHelp('Check application health')
        ;
    }

    #[Override]
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln('pong');

        return Command::SUCCESS;
    }
}
