<?php declare(strict_types=1);

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class HealthCheck
{
    #[Route(path: '/_/healthcheck', methods: ['GET'])]
    public function __invoke(): Response
    {
        return new Response('pong', Response::HTTP_OK);
    }
}
